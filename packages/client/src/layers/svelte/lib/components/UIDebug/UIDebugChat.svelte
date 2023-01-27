<script lang="ts">
  import type { Entity } from "../../../modules/entities";
  import { entities, baseEntities } from "../../../modules/entities";
  import { playerAddress } from "../../../modules/player";
  import { shortenAddress, addressToColor } from "../../../utils/ui";
  import { EntityType } from "./types";
  import { network } from "../../../modules/network";
  import { io } from "socket.io-client";

  export let channelId: string;

  let textInput = "";
  let messages: string[] = [];

  const socket = io.connect("wss://eda-relay.cygnet-service.com");

  socket.on("connect", () => {
    console.log("Connected to server");
  });

  socket.on("message", (data) => {
    console.log("Received message: " + data);
    messages.push(data);
  });

  function sendMessage() {
    socket.emit("message", textInput);
    textInput = "";
  }
</script>

<div class="debug-chat">
  chat: {channelId}
  <hr />
  <div>
    <input type="text" bind:value={textInput} />
    <button on:click={sendMessage}>Send</button>
  </div>
  <hr />
  <div>
    {#each messages as msg}
      <div>{msg}</div>
    {/each}
  </div>
</div>

<style>
  .debug-chat {
    position: fixed;
    bottom: 10px;
    left: 10px;
    padding: 10px;
    background: lightgray;
    border-radius: 5px;
    color: black;
  }

  .type {
    text-decoration: underline;
  }
</style>
