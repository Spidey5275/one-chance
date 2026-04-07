const revealItems = document.querySelectorAll(".reveal");
const forgiveButton = document.querySelector("#forgive-button");
const buttonMessage = document.querySelector("#button-message");

const tinyMessages = [
  "You mean a lot to me, Shreeyanshi. \uD83C\uDF80",
  "I am still hoping for one warm smile from you. \u2728",
  "Our friendship matters to me more than words can say. \u221E",
  "If hearts could write, mine would only say sorry. \uD83D\uDC97",
  "One more chance would mean the world to me. \uD83C\uDF38",
];

if (revealItems.length) {
  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.15 }
  );

  revealItems.forEach((item) => observer.observe(item));
}

if (forgiveButton && buttonMessage) {
  let messageIndex = 0;

  forgiveButton.addEventListener("click", () => {
    messageIndex = (messageIndex + 1) % tinyMessages.length;
    buttonMessage.textContent = tinyMessages[messageIndex];
  });
}
