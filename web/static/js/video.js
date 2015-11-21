import Player from "./player";

const Video = {
  init(socket, element) {
    if (!element) return;
    const msgContainer = document.getElementById("msg-container");
    const msgInput = document.getElementById("msg-input");
    const postButton = document.getElementById("msg-submit");
    const videoId = element.getAttribute("data-id");
    const playerId = element.getAttribute("data-player-id");

    Player.init(element.id, playerId);

    socket.connect();
    const vidChannel = socket.channel("videos:" + videoId);


    postButton.addEventListener("click", e => {
      const payload = {body: msgInput.value, at: Player.getCurrentTime()};
      vidChannel.push("new_annotation", payload)
        .receive("error", e => console.log(e));
      msgInput.value = "";
    });

    vidChannel.on("new_annotation", (resp) => {
      this.renderAnnotation(msgContainer, resp);
    });

    msgContainer.addEventListener("click", e => {
      e.preventDefault();
      const seconds = e.target.getAttribute("data-seek");
      if (!seconds) return;
      Player.seekTo(seconds);
    });

    vidChannel.join()
      .receive("ok", resp => console.log("joined the video channel", resp))
      .receive("error", reason => console.log("join failed", reason));
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    const template = document.createElement("div");
    template.innerHTML = `<b>${user.username}</b>: ${body}`;
    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  }
};

export default Video;

