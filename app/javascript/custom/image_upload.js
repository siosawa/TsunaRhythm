//画像投稿の際のフロント側でのいわばバリデーションを設定している。
document.addEventListener('turbo:load', () => {
  document.addEventListener('change', (event) => {
    const image_upload = document.querySelector('#micropost_image');

    const size_in_megabytes = image_upload.files[0].size / 1024 / 1024;

    if (size_in_megabytes > 5) {
      alert('Maximum file size is 5MB. Please choose a smaller file.');
      image_upload.value = '';
    }
  });
});
