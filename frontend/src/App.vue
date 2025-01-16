<template>
  <div>
    <h1>Welcome to Dockster</h1>
    <nav>
      <button @click="showLogs = !showLogs">
        {{ showLogs ? "Hide Logs" : "View Logs" }}
      </button>
    </nav>
    <div v-if="showLogs">
      <h2>System Logs</h2>
      <pre v-if="logs">{{ logs }}</pre>
      <p v-else>Loading logs...</p>
    </div>
  </div>
</template>

<script>
export default {
  name: "App",
  data() {
    return {
      showLogs: false, // Controls whether logs are displayed
      logs: "", // Holds the logs fetched from the backend
    };
  },
  watch: {
    showLogs(newVal) {
      if (newVal && !this.logs) {
        this.fetchLogs();
      }
    },
  },
  methods: {
    fetchLogs() {
      fetch("/api/logs")
        .then((response) => response.json())
        .then((data) => {
          if (data.logs) {
            this.logs = data.logs.join("\n");
          } else {
            this.logs = "No logs available.";
          }
        })
        .catch((error) => {
          console.error("Error fetching logs:", error);
          this.logs = "Error fetching logs.";
        });
    },
  },
};
</script>

<style>
pre {
  background-color: #f9f9f9;
  border: 1px solid #ddd;
  padding: 10px;
  overflow: auto;
  white-space: pre-wrap;
  word-wrap: break-word;
}
nav {
  margin-bottom: 10px;
}
</style>
