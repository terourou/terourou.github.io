class Header extends React.Component {
    render() {
        const [user, setUser] = React.useState(null)

        return (
            <header>
                <div>Member's Area</div>

                <div>
                    {user ? (
                        <a href="">Sign Out</a>
                    ) : (
                        <a href="">Sign In</a>
                    )}
                </div>
            </header>
        )
    }
}

class AdminApp extends React.Component {
    render() {
        const data = [1, 2, 3, 4, 5]

        return (
            <div>
                <Header />
            </div>
        )
    }
}

const domContainer = document.querySelector('#adminApp')
ReactDOM.render(<AdminApp />, domContainer)
