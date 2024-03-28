import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";
import { Col, Row } from "react-bootstrap";
import Login from "./Login";

function App() {
  return (
    <div className="Container app-container" role="parent">
      {/* RowとColはReact Bootstrapというフレームワーク。 */}
      <Row>
        <Col>
          <h1>Reactでチュートリアル</h1>
        </Col>
      </Row>
      <Row>
        <Col>
          <Login data-testid="child" />
        </Col>
      </Row>
    </div>
  );
}

export default App;
