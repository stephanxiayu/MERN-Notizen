import { Button, Container, Nav, Navbar } from "react-bootstrap"
import { User } from "../models/user"
import style from "../styles/NotesPage.module.css";
import NavBarLoggedInview from "./NavBarLoggedIn";
import NavBarLoggedoutView from "./NavBarLoggedoutView";
import {Link} from "react-router-dom"



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
                <Navbar.Brand style={{ color: 'black' }} as={Link} to="/" >
                    Meine Notizen
                </Navbar.Brand>
                <Navbar.Toggle aria-controls="main-navbar"/>
                <Navbar.Collapse id="main-navbar">
                <Nav>
                       
</Nav>

                    <Nav className="ms-auto">
                        {loggedInUser
                        
                        ?<NavBarLoggedInview  user={loggedInUser} onLogoutSuccessful={onLogoutSuccessful}/>
                        : <NavBarLoggedoutView onLoginClicked={onLoginClicked} onSignUpClicked={onSignUpClicked}/>
                    }
                    {/* <Button style={{ background: 'linear-gradient(90deg, #FFA500 0%, #FFFF00 50%, #FFA500 100%)', border: 'none' }}> */}
        {/* <Nav.Link  >
            <Link to={"/Datenschutz"} style={{ color: 'black' }}>
            Datenschutz
            </Link>
        </Nav.Link>
        <Nav.Link  >
            <Link to={"/Kontakt"} style={{ color: 'black' }}>
            Kontakt
            </Link>
        </Nav.Link> */}
    {/* </Button>      */}
                    </Nav>
                </Navbar.Collapse>
               
            </Container>
        </Navbar>
         
    )
}
export default NavBar
