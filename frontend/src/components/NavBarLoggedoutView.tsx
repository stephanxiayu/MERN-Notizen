import { Button } from "react-bootstrap";
import styles from "./styles/NotesPage.module.css";

interface NavBarLoggedoutViewProps{
    onSignUpClicked:()=>void
    onLoginClicked:()=>void
}


const NavBarLoggedoutView = ({onSignUpClicked,onLoginClicked}:NavBarLoggedoutViewProps) => {
    return ( 
        <>
        <Button
            style={{ backgroundColor: 'white', border: 'none',color: 'black' }}
            onClick={onSignUpClicked}>
            kostenloses Konto erstellen
        </Button>
        <Button
            style={{ backgroundColor: 'white',border: 'none', color: 'black' }}
            onClick={onLoginClicked}>
            einloggen
        </Button>
        </>
     );
}
 
export default NavBarLoggedoutView;