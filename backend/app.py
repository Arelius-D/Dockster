from flask import Flask, jsonify, send_from_directory, request
import os
import logging

# Initialize Flask app
app = Flask(__name__, static_folder="static")

# Configure Logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler("/app/backend/logs/app.log"),
        logging.StreamHandler(),
    ],
)
logger = logging.getLogger(__name__)

# Health Check Endpoint
@app.route("/api/health", methods=["GET"])
def health():
    logger.info("Health check endpoint was called.")
    return jsonify({"status": "healthy"}), 200

# Logs Endpoint
@app.route("/api/logs", methods=["GET"])
def get_logs():
    log_file_path = "/app/backend/logs/app.log"
    logger.info(f"Logs requested. Serving logs from {log_file_path}")
    if os.path.exists(log_file_path):
        with open(log_file_path, "r") as log_file:
            logs = log_file.readlines()
        return jsonify({"logs": logs})
    else:
        logger.warning("Log file not found.")
        return jsonify({"error": "Log file not found."}), 404

# Update Script Logs Endpoint
@app.route("/api/logs/update", methods=["GET"])
def get_update_logs():
    log_file_path = "/srv/logs/update.log"
    logger.info(f"Update logs requested. Serving logs from {log_file_path}")
    if os.path.exists(log_file_path):
        with open(log_file_path, "r") as log_file:
            logs = log_file.readlines()
        return jsonify({"logs": logs})
    else:
        logger.warning("Update log file not found.")
        return jsonify({"error": "Update log file not found."}), 404

# Trigger Command Endpoint
@app.route("/api/trigger", methods=["POST"])
def trigger_command():
    data = request.json
    command = data.get("command")
    if not command:
        logger.error("No command provided.")
        return jsonify({"error": "No command provided."}), 400

    try:
        logger.info(f"Executing command: {command}")
        os.system(command)
        return jsonify({"status": f"Command '{command}' executed successfully."})
    except Exception as e:
        logger.error(f"Error executing command: {e}")
        return jsonify({"error": str(e)}), 500

# Serve Frontend Files
@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve(path):
    logger.info(f"Requested path: {path}")
    static_path = os.path.join(app.static_folder, path)
    logger.info(f"Resolved static path: {static_path}")
    if path != "" and os.path.exists(static_path):
        return send_from_directory(app.static_folder, path)
    else:
        return send_from_directory(app.static_folder, "index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050, debug=False)
