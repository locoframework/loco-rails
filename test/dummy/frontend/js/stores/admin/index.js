import { createStore } from "redux";

import reducer from "reducers/admin";

const store = createStore(reducer, { users: [] });

export default store;
