<script lang="ts">
  import { loadingMessage } from "../../modules/network";
</script>

<div class="ui-loading">
  <div class="introduction-text">
    you exist in this darkness,<br />in the cracks of abandoned buildings,<br />in the ruins of decrepit myths...
  </div>
  <div class="loading-message">{$loadingMessage}</div>
</div>

<style>
  .ui-loading {
    width: 100%;
    height: 100%;
    text-align: center;
  }

  .loading-message {
    margin-top: 1em;
    opacity: 0.5;
  }
</style>
