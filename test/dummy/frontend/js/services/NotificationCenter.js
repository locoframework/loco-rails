import { getChat } from "services/app";

import {
  created as articleCreated,
  destroyed as articleDestroyed,
  published as articlePublished,
  updated as articleUpdated,
  updating as articleUpdating,
} from "reactions/articles";

import {
  created as commentCreated,
  destroyed as commentDestroyed,
  updated as commentUpdated,
} from "reactions/comments";

import {
  created as roomCreated,
  destroyed as roomDestroyed,
  memberJoined as roomMemberJoined,
  memberLeft as roomMemberLeft,
} from "reactions/rooms";

import {
  created as userCreated,
  confirmed as userConfirmed,
} from "reactions/users";

import { userNamespace } from "services/namespace";

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
    case "Article created":
      articleCreated(payload);
      break;
    case "Article published":
      articlePublished(payload);
      break;
    case "Article updating":
      articleUpdating(payload);
      break;
    case "Article updated":
      articleUpdated(payload);
      break;
    case "Article destroyed":
      articleDestroyed(payload);
      break;
    case "Article.Comment created":
      commentCreated(payload);
      break;
    case "Article.Comment destroyed":
      commentDestroyed(payload);
      break;
    case "Article.Comment updated":
      commentUpdated(payload);
      break;
    case "Room created":
      roomCreated(payload);
      break;
    case "Room destroyed":
      roomDestroyed(payload);
      break;
    case "Room member_joined":
      roomMemberJoined(payload);
      break;
    case "Room member_left":
      roomMemberLeft(payload);
      break;
    case "User created":
      userCreated(payload);
      break;
    case "User confirmed":
      userConfirmed(payload);
      break;
  }
};
