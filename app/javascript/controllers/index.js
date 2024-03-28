//インタラクティブ機能を提供するStimulusをContllolerと繋げている
import { application } from 'controllers/application';

import { eagerLoadControllersFrom } from '@hotwired/stimulus-loading';

eagerLoadControllersFrom('controllers', application);

