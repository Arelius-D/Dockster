<template>
  <div>
    <h1>Welcome to Dockster</h1>
    <nav>
      <button @click="showDockerLogs = !showDockerLogs">
        {{ showDockerLogs ? "Hide Docker Logs" : "Show Docker Logs" }}
      </button>
      <button @click="showUpdateLogs = !showUpdateLogs">
        {{ showUpdateLogs ? "Hide Update Logs" : "Show Update Logs" }}
      </button>
      <button @click="triggerCommand('apt-get update')">Run Update</button>
    </nav>

    <section v-if="showDockerLogs">
      <h2>Docker Logs</h2>
      <pre v-if="dockerLogs">{{ dockerLogs }}</pre>
      <p v-else>Loading Docker logs...</p>
    </section>

    <section v-if="showUpdateLogs">
      <h2>Update Logs</h2>
      <pre v-if="updateLogs">{{ updateLogs }}</pre>
      <p v-else>Loading Update logs...</p>
    </section>
  </div>
</template>

<script>
export default {
  name: "App",
  data() {
    return {
      showDockerLogs: false,
      showUpdateLogs: false,
      dockerLogs: "",
      updateLogs: "",
    };
  },
  methods: {
    fetchDockerLogs() {
      fetch("/api/logs")
        .then((response) => response.json())
        .then((data) => {
          if (data.logs) {
            this.dockerLogs = data.logs.join("\n");
          } else {
            this.dockerLogs = "No Docker logs available.";
          }
        })
        .catch((error) => {
          console.error("Error fetching Docker logs:", error);
          this.dockerLogs = "Error fetching Docker logs.";
        });
    },
    fetchUpdateLogs() {
      fetch("/api/logs/update")
        .then((response) => response.json())
        .then((data) => {
          if (data.logs) {
            this.updateLogs = data.logs.join("\n");
          } else {
            this.updateLogs = "No Update logs available.";
          }
        })
        .catch((error) => {
          console.error("Error fetching Update logs:", error);
          this.updateLogs = "Error fetching Update logs.";
        });
    },
    triggerCommand(command) {
      fetch("/api/trigger", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ command }),
      })
        .then((response) => response.json())
        .then((data) => {
          alert(data.status || data.error);
        })
        .catch((error) => {
          console.error("Error triggering command:", error);
          alert("Error triggering command.");
        });
    },
  },
  watch: {
    showDockerLogs(newValue) {
      if (newValue && !this.dockerLogs) {
        this.fetchDockerLogs();
      }
    },
    showUpdateLogs(newValue) {
      if (newValue && !this.updateLogs) {
        this.fetchUpdateLogs();
      }
    },
  },
};
</script>

<style>
body {
  font-family: Arial, sans-serif;
  line-height: 1.6;
  margin: 0;
  padding: 0;
}
nav {
  margin-bottom: 20px;
}
button {
  margin-right: 10px;
  padding: 10px 20px;
  font-size: 16px;
  border: none;
  border-radius: 5px;
  background-color: #007bff;
  color: white;
  cursor: pointer;
}
button:hover {
  background-color: #0056b3;
}
pre {
  background: #f4f4f4;
  border: 1px solid #ddd;
  padding: 15px;
  overflow: auto;
  white-space: pre-wrap;
  word-wrap: break-word;
}
</style>
