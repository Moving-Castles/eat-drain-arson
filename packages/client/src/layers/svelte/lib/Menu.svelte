<script lang="ts">
  let open = false;

  const interfaceComponents = [
    {
      name: "clock",
    },
    {
      name: "view",
    },
    {
      name: "grid",
    },
    {
      name: "log",
    },
    {
      name: "fire",
    },
    {
      name: "character",
    },
  ];

  const toggleMenu = () => {
    open = !open;
  };
</script>

<div class="menu" on:click={toggleMenu}>
  {#if open}
    {#each interfaceComponents as component}
      <div>[x] {component.name}</div>
    {/each}
  {:else}
    menu
  {/if}
</div>

<style>
  .menu {
    border: 1px solid white;
    color: white;
    padding: 10px;
    user-select: none;
    cursor: pointer;
  }
</style>
