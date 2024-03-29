//ハンバーガーメニューの動的な設定をしている
document.addEventListener('turbo:load', () => {
  console.log('ページが読み込まれました。イベントリスナーが設定されています。');

  const hamburger = document.querySelector('#hamburger');
  hamburger.addEventListener('click', (event) => {
    event.preventDefault();
    const menu = document.querySelector('#navbar-menu');
    menu.classList.toggle('collapse');
    console.log('ハンバーガーメニューがクリックされました。メニューの表示状態が切り替わりました。');
  });

  const account = document.querySelector('#account');
  account.addEventListener('click', (event) => {
    event.preventDefault();
    const menu = document.querySelector('#dropdown-menu');
    menu.classList.toggle('active');
    console.log('アカウントメニューがクリックされました。ドロップダウンメニューの表示状態が切り替わりました。');
  });
});

