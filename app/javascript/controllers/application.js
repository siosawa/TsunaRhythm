// インタラクティブ機能を提供するStimulusを実際の画面上で起動させている
import { Application } from '@hotwired/stimulus';

const application = Application.start();

application.debug = false;
window.Stimulus = application;

export { application };
