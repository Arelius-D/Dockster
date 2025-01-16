<template>
  <div>
    <h1>System Logs</h1>
    <pre v-if="logs">{{ logs }}</pre>
    <p v-else>Loading logs...</p>
  </div>
</template>

<script>
export default {
  name: 'Logs',
  data() {
    return {
      logs: "",
    };
  },
  mounted() {
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
</style>
