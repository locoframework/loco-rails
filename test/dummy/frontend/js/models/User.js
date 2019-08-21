import { Models } from "loco-js";

class User extends Models.Base {
  static identity = "User";

  static resources = {
    url: "/users",
    admin: {
      url: "/admin/users"
    }
  };

  static paginate = { per: 10 };

  static attributes = {
    email: {
      validations: {
        presence: true,
        format: { with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }
      }
    },
    username: {
      validations: {
        presence: true,
        format: { with: /^[a-z][a-z0-9_-]*$/i }
      }
    },
    password: {
      validations: {
        presence: { on: "create" },
        confirmation: true
      }
    },
    passwordConfirmation: {
      remoteName: "password_confirmation"
    },
    confirmed: {},
    createdAt: {
      type: "Date",
      remoteName: "created_at"
    },
    updatedAt: {
      type: "Date",
      remoteName: "updated_at"
    }
  };

  static receivedSignal(signal) {
    console.log(`User.receivedSignal: ${signal}`);
  }

  constructor(data) {
    super(data);
  }

  receivedSignal(signal) {
    console.log(`User#receivedSignal: ${signal}`);
  }
}

export default User;
