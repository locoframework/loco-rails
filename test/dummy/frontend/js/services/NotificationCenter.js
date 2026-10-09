import { getChat } from "services/app";

import * as articles from "reactions/articles";
import * as comments from "reactions/comments";
import * as rooms from "reactions/rooms";
import * as users from "reactions/users";

import { userNamespace } from "services/namespace";

const REACTIONS = {
  Article: [
    articles,
    ["created", "published", "updating", "updated", "destroyed"],
  ],
  "Article.Comment": [comments, ["created", "destroyed", "updated"]],
  Room: [rooms, ["created", "destroyed", "member_joined", "member_left"]],
  User: [users, ["created", "confirmed"]],
};

const react = (type, payload) => {
  const [model, event] = type.split(" ");
  const [reactions, events] = REACTIONS[model] ?? [];
  if (events?.includes(event))
    reactions[event.replace(/_(\w)/g, (_, c) => c.toUpperCase())](payload);
};

const ping = () => {
  if (!userNamespace()) return;
  alert("Ping!");
};

export default async (data) => {
  const { type, payload, loco } = data;

  if (loco === "disconnected") return getChat()?.disconnected();

  switch (type) {
    case "PING":
      ping();
      break;
    case "NEW_MESSAGE":
      getChat()?.receivedMessage(payload.message, payload.author);
      break;
    default:
      react(type, payload);
  }
};
