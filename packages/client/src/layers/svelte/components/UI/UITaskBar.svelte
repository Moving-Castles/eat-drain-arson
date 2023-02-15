<script lang="ts">
  import UIBlockCounter from "./UIBlockCounter.svelte";
</script>

<div class="ui-taskbar">
  <div>
    <UIBlockCounter />
  </div>
</div>

<style>
  .ui-taskbar {
    box-sizing: border-box;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    user-select: none;
    height: var(--taskbar-height);
  }
</style>
