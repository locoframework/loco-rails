import LocoReactive from "models/LocoReactive";
import AdminUser from "components/admin/User";

class User extends LocoReactive {
  static name = "User";

  static components = [AdminUser];

  static resources = {
    url: "/users",
    admin: {
      url: "/admin/users",
    },
  };

  static paginate = { per: 10 };

  static attributes = {
    email: {
      validations: {
        presence: true,
        format: { with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
      },
    },
    username: {
      validations: {
        presence: true,
        format: { with: /^[a-z][a-z0-9_-]*$/i },
      },
    },
    password: {
      validations: {
        presence: { on: "create" },
        confirmation: true,
      },
    },
    passwordConfirmation: {
      remoteName: "password_confirmation",
    },
    confirmed: {},
    createdAt: {
      type: "Date",
      remoteName: "created_at",
    },
    updatedAt: {
      type: "Date",
      remoteName: "updated_at",
    },
  };
}

export default User;
