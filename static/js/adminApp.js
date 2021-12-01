var _slicedToArray = function () { function sliceIterator(arr, i) { var _arr = []; var _n = true; var _d = false; var _e = undefined; try { for (var _i = arr[Symbol.iterator](), _s; !(_n = (_s = _i.next()).done); _n = true) { _arr.push(_s.value); if (i && _arr.length === i) break; } } catch (err) { _d = true; _e = err; } finally { try { if (!_n && _i["return"]) _i["return"](); } finally { if (_d) throw _e; } } return _arr; } return function (arr, i) { if (Array.isArray(arr)) { return arr; } else if (Symbol.iterator in Object(arr)) { return sliceIterator(arr, i); } else { throw new TypeError("Invalid attempt to destructure non-iterable instance"); } }; }();

var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var Header = function (_React$Component) {
    _inherits(Header, _React$Component);

    function Header() {
        _classCallCheck(this, Header);

        return _possibleConstructorReturn(this, (Header.__proto__ || Object.getPrototypeOf(Header)).apply(this, arguments));
    }

    _createClass(Header, [{
        key: "render",
        value: function render() {
            var _React$useState = React.useState(null),
                _React$useState2 = _slicedToArray(_React$useState, 2),
                user = _React$useState2[0],
                setUser = _React$useState2[1];

            return React.createElement(
                "header",
                null,
                React.createElement(
                    "div",
                    null,
                    "Member's Area"
                ),
                React.createElement(
                    "div",
                    null,
                    user ? React.createElement(
                        "a",
                        { href: "" },
                        "Sign Out"
                    ) : React.createElement(
                        "a",
                        { href: "" },
                        "Sign In"
                    )
                )
            );
        }
    }]);

    return Header;
}(React.Component);

var AdminApp = function (_React$Component2) {
    _inherits(AdminApp, _React$Component2);

    function AdminApp() {
        _classCallCheck(this, AdminApp);

        return _possibleConstructorReturn(this, (AdminApp.__proto__ || Object.getPrototypeOf(AdminApp)).apply(this, arguments));
    }

    _createClass(AdminApp, [{
        key: "render",
        value: function render() {
            var data = [1, 2, 3, 4, 5];

            return React.createElement(
                "div",
                null,
                React.createElement(Header, null)
            );
        }
    }]);

    return AdminApp;
}(React.Component);

var domContainer = document.querySelector('#adminApp');
ReactDOM.render(React.createElement(AdminApp, null), domContainer);