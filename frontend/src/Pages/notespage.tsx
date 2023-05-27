import { Container } from "react-bootstrap";
import NotePageLoggedin from "../components/NotePageLoggedin";
import NotePageLoggedoutview from "../components/NotePageLoggedoutview";
import { User } from "../models/user";
interface NotesPageProps{
    loggedInUser:User|null
}

const NotesPage = ({loggedInUser}: NotesPageProps) => {
    return ( 
        <Container >
        <>
        {loggedInUser?
        <NotePageLoggedin/>
        : <NotePageLoggedoutview/>
        }
        </>
       
        </Container>
     );
}
 
export default NotesPage