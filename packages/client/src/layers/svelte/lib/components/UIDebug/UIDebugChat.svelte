<script lang="ts">
  import { playerAddress, playerCore } from "../../../modules/player";
  import { shortenAddress, addressToColor } from "../../../utils/ui";
  export let channelId: string;

  type Message = {
    id: string;
    channel: string;
    text: string;
  };

  let textInput = "";
  let messages: Message[] = [];

  // Create WebSocket connection.
  const socket = new WebSocket("wss://eda-relay.cygnet-service.com");

  // Connection opened
  socket.addEventListener("open", (event) => {
    console.log("Connected");
  });

  // Listen for messages
  socket.addEventListener("message", (event) => {
    console.log("Message from server ", event.data);
    event.data.text().then((txt: string) => {
      let msgObj = JSON.parse(txt);
      if (msgObj.channel === $playerCore.carriedBy) {
        messages = [...messages, { id: msgObj.id, channel: msgObj.channel, text: msgObj.text }];
      }
    });
  });

  function sendMessage() {
    socket.send(JSON.stringify({ id: $playerAddress, channel: $playerCore.carriedBy, text: textInput }));
    textInput = "";
  }
</script>

<div class="debug-chat">
  chat: <span style={"background:" + addressToColor(channelId) + ";"}>{shortenAddress(channelId)}</span>
  <hr />
  <div>
    <input type="text" bind:value={textInput} />
    <button on:click={sendMessage}>Send</button>
  </div>
  <hr />
  <div>
    {#each messages as msg}
      <div>
        <span style={"background:" + addressToColor(msg.id) + ";"}>{shortenAddress(msg.id)}</span>: {msg.text}
      </div>
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
