// // 巨大画像のアップロードを防止する
// document.addEventListener("turbo:load", function() {
//   document.addEventListener("change", function(event) {
//     let image_upload = document.querySelector('#micropost_image');
//     const size_in_megabytes = image_upload.files[0].size/1024/1024;
//     if (size_in_megabytes > 5) {
//       alert("Maximum file size is 5MB. Please choose a smaller file.");
//       image_upload.value = "";
//     }
//   });
// });

// Turboリンク（Railsの特徴的な機能）を使用するページがロードされるたびに実行されるイベントリスナー。
document.addEventListener('turbo:load', () => {
  // 任意の要素が変更されたときに発火するイベントリスナー。
  document.addEventListener('change', (event) => {
    // IDが 'micropost_image' の要素（画像アップロードフィールド）を取得。
    const image_upload = document.querySelector('#micropost_image');

    // 選択されたファイルのサイズをメガバイト単位で取得。
    const size_in_megabytes = image_upload.files[0].size / 1024 / 1024;

    // ファイルサイズが5MBを超える場合の処理。
    if (size_in_megabytes > 5) {
      // ユーザーに警告メッセージを表示。
      alert('Maximum file size is 5MB. Please choose a smaller file.');

      // アップロードフィールドをリセット。
      image_upload.value = '';
    }
  });
});
