import { Container, Nav, Navbar } from "react-bootstrap"
import { User } from "../models/user"
import styles from "../styles/NotesPage.module.css";
import NavBarLoggedInview from "./NavBarLoggedIn";
import NavBarLoggedoutView from "./NavBarLoggedoutView";


interface NavBarProps{
    loggedInUser:User|null
    onSignUpClicked:()=>void
    onLoginClicked:()=>void
    onLogoutSuccessful:()=>void
}

const NavBar =({loggedInUser,onSignUpClicked, onLoginClicked, onLogoutSuccessful}: NavBarProps)=>{
    return(
        <Navbar style={{ background: 'linear-gradient(90deg, #FFA500 0%, #FFFF00 50%, #FFA500 100%)', border: 'none', color: 'black' }} variant="dark" expand="sm" sticky="top">
            <Container>
                <Navbar.Brand style={{ color: 'black' }}>
                    Meine Notizen
                </Navbar.Brand>
                <Navbar.Toggle aria-controls="main-navbar"/>
                <Navbar.Collapse id="main-navbar">
                    <Nav className="ms-auto">
                        {loggedInUser
                        
                        ?<NavBarLoggedInview  user={loggedInUser} onLogoutSuccessful={onLogoutSuccessful}/>
                        : <NavBarLoggedoutView onLoginClicked={onLoginClicked} onSignUpClicked={onSignUpClicked}/>
                    }
                    </Nav>
                </Navbar.Collapse>
               
            </Container>
        </Navbar>
    )
}
export default NavBar
