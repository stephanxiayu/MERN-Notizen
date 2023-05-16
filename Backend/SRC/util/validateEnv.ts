import { cleanEnv, port, str } from "envalid";


export default cleanEnv(process.env,{
    Mongo_CONNECTION_STRING: str(),
    PORT:port(),
    Session_SECRET:str()
})