import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import Login, { validateEmail } from "../Login";
// setupTestes.jsがあるのでjestをインポートする必要がない
// Promise処理という非同期処理が行われている。
describe("ログインコンポーネントテスト", () => {
  test("ボタンが1つのみ表示されているか", async () => {
    render(<Login />);
    const buttonList = await screen.findAllByRole("button");
    // console.log(buttonList);
    expect(buttonList).toHaveLength(1);
  });

  test("不適切なメールアドレスの際にバリデーションが失敗する", () => {
    const testEmail = "shincode.com";
    expect(validateEmail(testEmail)).not.toBe(true);
  });

  test("適切なメールアドレスのときにバリデーションが成功する", () => {
    const testEmail = "shincode@gmail.com";
    expect(validateEmail(testEmail)).toBe(true);
  });

  test("パスワード属性になっているか", () => {
    // 関数のテストではなくDOM要素のテストを行っているのでLoginコンポーネントの読み込みが必要
    render(<Login />);
    const password = screen.getByPlaceholderText("パスワード入力");
    expect(password).toHaveAttribute("type", "password");
  });

  // test("ボタンが押されたときフォームを送信できているか", () => {
  //     render(<Login />);
  //     const submitButton = screen.getByTestId("submit");
  //     const email =        screen.getByPlaceholderText("メールアドレス入力");
  //     const password =     screen.getByPlaceholderText("パスワード入力");

  //     userEvent.type(email,"shincode@gmail.com");
  //     userEvent.type(password,"foobar");

  //     userEvent.click(submitButton);
  //     const userInfo = screen.getByText("shincode@gmail.com");
  //     expect(userInfo).toBeInTheDocument();
  // });

  test("ボタンが押されたときフォームを送信できているか", async () => {
    // async を追加
    render(<Login />);
    const submitButton = screen.getByTestId("submit");
    const email = screen.getByPlaceholderText("メールアドレス入力");
    const password = screen.getByPlaceholderText("パスワード入力");

    await userEvent.type(email, "shincode@gmail.com"); // await を追加
    await userEvent.type(password, "foobar"); // await を追加

    await userEvent.click(submitButton); // await を追加
    const userInfo = await screen.findByText("shincode@gmail.com"); // findByText を使用して非同期の表示を待つ
    expect(userInfo).toBeInTheDocument();
  });
});
