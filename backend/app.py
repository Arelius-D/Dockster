from flask import Flask, send_from_directory, jsonify
import os
import logging

# Initialize Flask app
app = Flask(__name__, static_folder="static")

# Configure Logging
logging.basicConfig(
    level=logging.INFO,  # Log level: DEBUG, INFO, WARNING, ERROR, CRITICAL
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler("/app/backend/logs/app.log"),  # Log to a file
        logging.StreamHandler(),  # Log to the console
    ],
)
logger = logging.getLogger(__name__)

# Health Check Endpoint
@app.route("/api/health", methods=["GET"])
def health():
    logger.info("Health check endpoint was called.")
    return jsonify({"status": "healthy"}), 200

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

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050, debug=False)
