import { Link } from 'react-router-dom';

const Footer = () => {
    return (
        <footer style={{ background: 'transparent', textAlign: 'center', padding: '20px', position: 'fixed', left: '0', bottom: '0', width: '100%' }}>
           <Link to="/Datenschutz" style={{ color: 'black', marginRight: '15px', fontWeight: 'bold', fontSize: '18px' }}>Datenschutz</Link>
<Link to="/Kontakt" style={{ color: 'black', fontWeight: 'bold', fontSize: '18px' }}>Kontakt</Link>

        </footer>
    );
}

export default Footer