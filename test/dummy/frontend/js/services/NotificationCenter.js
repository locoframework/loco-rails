import getEnv from "initializers/loco-core";

import {
  created as articleCreated,
  published as articlePublished,
  updated as articleUpdated,
} from "reactions/articles";

import {
  created as commentCreated,
  destroyed as commentDestroyed,
  updated as commentUpdated,
} from "reactions/comments";

import {
  created as userCreated,
  confirmed as userConfirmed,
} from "reactions/users";

import { inChatRoom, userNamespace } from "services/namespace";

const ping = () => {
  if (!userNamespace()) return;
  alert("Ping!");
};

const getCallbackForNewMessage = () => {
  if (!inChatRoom()) return () => {};
  return getEnv().controller.view.receivedMessage;
};

const wsDisconnected = () => {
  if (inChatRoom()) getEnv().controller.view.disconnected();
};

export default async (data) => {
  const { type, payload, loco } = data;

  if (loco === "disconnected") return wsDisconnected();

  switch (type) {
    case "PING":
      ping();
      break;
    case "NEW_MESSAGE":
      getCallbackForNewMessage()(payload.message, payload.author);
      break;
    case "Article created":
      articleCreated(payload);
      break;
    case "Article published":
      articlePublished(payload);
      break;
    case "Article updated":
      articleUpdated(payload);
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
    case "User created":
      userCreated(payload);
      break;
    case "User confirmed":
      userConfirmed(payload);
      break;
  }
};
