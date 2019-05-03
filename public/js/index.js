function make(e) {
  e.target.classList.add("is-loading");
  let subtitles = [];
  document.querySelectorAll(".zx-subtitles input").forEach(input => {
    let value = input.value || input.placeholder;
    subtitles.push(value);
  });
  let data = {
    subtitles: subtitles
  };
  let path = document.querySelector("#makeBtn").getAttribute("data");
  fetch(`/${path}/make`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(data)
    })
    .then(resp => resp.text())
    .then(hash => updateVideo(hash));
}

function updateVideo(hash) {
  document.querySelector("video source").src = `/download/${hash}/mp4`;
  document.querySelector("video").load();
  document.querySelector("#makeBtn").classList.remove("is-loading");
  document.querySelector("#makeResult1").innerHTML = `通过右键保存视频（MP4）`;
  document.querySelector("#makeResult2").innerHTML = `点击<a target="_blank" href="/download/${hash}/gif">这里</a>下载动图（GIF）`
}

document.getElementById("makeBtn").addEventListener("click", make);