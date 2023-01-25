<script lang="ts">
  import Pusher from "pusher-js";
  import type { Entity } from "../../../modules/entities";
  import { entities, baseEntities } from "../../../modules/entities";
  import { playerAddress } from "../../../modules/player";
  import { shortenAddress, addressToColor } from "../../../utils/ui";
  import { EntityType } from "./types";
  import { network } from "../../../modules/network";

  export let channelId: string;

  let textInput = "";

  const pusher = new Pusher("xxxx", {
    cluster: "eu",
  });

  const channel = pusher.subscribe("private" + channelId);

  console.log(channel);

  channel.bind("client-chat", (data) => {
    console.log(data);
  });

  function sendMessage() {
    let triggered = channel.trigger("client-chat", "xxxxxxx");
    console.log(triggered);
  }
</script>

<div class="debug-chat">
  chat: {channelId}
  <hr />
  <div>
    <button on:click={sendMessage}>Send</button>
  </div>
  <hr />
  <div>Messages</div>
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
