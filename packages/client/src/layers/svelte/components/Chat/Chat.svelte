<script lang="ts">
  import { playerAddress, playerCore } from "../../modules/player";
  import { shortenAddress, addressToColor } from "../../utils/ui";
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
        messages = [{ id: msgObj.id, channel: msgObj.channel, text: msgObj.text }, ...messages];
      }
    });
  });

  function sendMessage() {
    socket.send(JSON.stringify({ id: $playerAddress, channel: $playerCore.carriedBy, text: textInput }));
    textInput = "";
  }
</script>

<div class="debug-chat">
  chat:
  {#if channelId}
    <span style={"background:" + addressToColor(channelId) + ";"}>{shortenAddress(channelId)}</span>
  {:else}
    <span class="void">Ţ̶̨̡̡̣̮͓̪̖̦̱͍͖̭͖̠̱̣͕͔̊̀̚͜͝͠ͅH̷̛͚̟̮̜͖͔̳̬̳̱͇̩̙͚͍̿͑͂̀̑̈͗́͊̏̇̈́͛̄̑̇͐̂̍͗̈́͑̽̉̾̚̚̚͘̕͘̕Ë̸̮̘̠͉͛́͆̈́̔̍̐͛͒͊̏͠͠ͅ ̷̧̧̡̝̩̱̰̠̖̳̤͉̪͓̭̤̙̞͈͉̝͍̫̘͇̫̙̦̘̬̻̝̣̰̺̼̘͕͖̜̯̖̿V̴̡̧̨̨̯͔̯̖̪̫̞̯̫̩͇̬͔̟̥͖̹̪̊̂̆̅̀̆͋̒͌̇̆̂͂̊͑̀̅͌͘̚͜͠͝ͅO̸̬̘̭̖̠̥̰͔͎̲̼͈̟͚̙͉̙̰͉͉̱̙̹͉̪̹̪͕̣̭͚̲̺̪̙̞̻͋̋̔͛̀̀̃̆̂̇̀͌́̽̽̇̾̀̐Į̷̢̨̧̨̛̛̻̲͖̞͔̱͔̺̻̹̯̹̱̻̰̥̹̤̘̣̞̹̺̞̬̜̭̜̤̦̟̟̟̳͙̙̭̗͚̥̼̽̓̋͂́̐̓́̿̀͌̔́̔̀̊̅͘̚͜͝͝D̵̨̨̨̡̛̛̮̟͚̺̺̟̥̹̱̺̜̬͓͙̗̩͓̟͕͎̜̗̦̪̟̟͔̞̘̰̏̾͋̂̆͂̽̎̇̐̈́̎̑͌͐̆̓͗̾̓͛͛̏̽̋̑͗̄͌͘̚͜͝͝͠</span>
  {/if}
  <hr />
  <div>
    <input
      type="text"
      bind:value={textInput}
      on:keydown={(e) => {
        console.log(e.key);
        if (e.key === "Enter") {
          sendMessage();
        }
      }}
    />
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
    bottom: 40px;
    left: 40px;
    padding: 10px;
    background: lightgray;
    border-radius: 5px;
    color: black;
    z-index: 1000000;
    width: 300px;
    max-width: 90vw;
    max-height: 70vh;
    overflow-y: auto;
  }

  .type {
    text-decoration: underline;
  }

  .void {
    font-size: 64px;
  }
</style>
