const scale = 10;
let mml = null;
let pml = null;

function newmaze() {
  fetch("/api/v0.1/maze", {method: "POST"}).then(function(resp) {
    resp.text().then(function(text) {
      let t = text.split("\n");
      mml = t;
      pml = null;
    });
  });
}

function newpath() {
  fetch("/api/v0.1/path", {method: "POST"}).then(function(resp) {
    fetch("/api/v0.1/path/valid").then(function(resp) {
      resp.text().then(function(text) {
        if(text.includes("true")) {
          fetch("/api/v0.1/path").then(function(resp) {
            resp.text().then(function(text) {
              pml = text.split("\n");
            });
          });
        }
      });
    });
  });
}

function setup() {
  fetch("/api/v0.1/maze").then(function(resp) {
    resp.text().then(function(text) {
      let t = text.split("\n");
      const wh = t[0].split(" ");
      createCanvas(wh[0] * scale + 50, wh[1] * scale + 50);
      createButton("Generate Maze").mousePressed(newmaze);
      createButton("Find Path").mousePressed(newpath);
      mml = t;
    });
  });
}

function draw() {
  if(mml) {
    background(255);

    stroke(0);
    strokeWeight(1);
    noFill();

    let wh = mml[0].split(" ");
    for(let col = 0; col < wh[0]; col++) {
      for(let row = 0; row < wh[1]; row++) {
        rect(col * scale, row * scale, scale, scale);
      }
    }

    fill(0, 128, 0);
    let start = mml[1].split(" ");
    rect(start[0] * scale, start[1] * scale, scale, scale);

    fill(128, 0, 0);
    let target = mml[2].split(" ");
    rect(target[0] * scale, target[1] * scale, scale, scale);

    noStroke();
    fill(0);

    for(let b = 3; b < mml.length; b++) {
      let blk = mml[b].split(" ");
      rect(blk[0] * scale, blk[1] * scale, blk[2] * scale, blk[3] * scale);
    }

    if(pml) {
      stroke(0);
      strokeWeight(1);
      fill(0, 0, 128);

      for(let b = 0; b < pml.length; b++) {
        let blk = pml[b].split(" ");
        rect(blk[0] * scale, blk[1] * scale, scale, scale);
      }
    } else {
      text("No path", 10, wh[1] * scale + 20);
    }
  }
}
