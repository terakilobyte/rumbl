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
      .receive("ok", resp => {
        console.log(JSON.stringify(resp, null, 4));
        this.scheduleMessages(msgContainer, resp.annotations);
      })
      .receive("error", reason => console.log("join failed", reason));
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    const template = document.createElement("div");
    template.innerHTML = `
      <a href="#" data-seek="${at}">
        <b>${user.username}</b>: ${body}
      </a>
    `;
    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  },

  scheduleMessages(msgContainer, annotations) {
    setTimeout(() => {
      const ctime = Player.getCurrentTime();
      const remaining = this.renderAtTime(annotations, ctime, msgContainer);
      this.scheduleMessages(msgContainer, remaining);
    }, 1000);
  },

  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter( ann => {
      if (ann.at > seconds) {
        return true;
      } else {
        this.renderAnnotation(msgContainer, ann);
        return false;
      }
    });
  },

  formatTime(at) {
    const date = new Date(null);
    date.setSeconds(at / 1000);
    return date.toISOString().substr(14, 5);
  }
};
export default Video;

