import React, { PureComponent } from 'react';
import PropTypes from 'prop-types';
import BreakoutRoomContainer from '/imports/ui/components/breakout-room/container';
import UserListContainer from '/imports/ui/components/user-list/container';
import ChatContainer from '/imports/ui/components/chat/container';
import NoteContainer from '/imports/ui/components/note/container';
import PollContainer from '/imports/ui/components/poll/container';
import CaptionsContainer from '/imports/ui/components/captions/pad/container';
import WaitingUsersPanel from '/imports/ui/components/waiting-users/container';
import { defineMessages, injectIntl } from 'react-intl';
import Resizable from 're-resizable';
import { styles } from '/imports/ui/components/app/styles';
import _ from 'lodash';

const intlMessages = defineMessages({
  chatLabel: {
    id: 'app.chat.label',
    description: 'Aria-label for Chat Section',
  },
  noteLabel: {
    id: 'app.note.label',
    description: 'Aria-label for Note Section',
  },
  captionsLabel: {
    id: 'app.captions.label',
    description: 'Aria-label for Captions Section',
  },
  userListLabel: {
    id: 'app.userList.label',
    description: 'Aria-label for Userlist Nav',
  },
});

const propTypes = {
  intl: PropTypes.shape({
    formatMessage: PropTypes.func.isRequired,
  }).isRequired,
  enableResize: PropTypes.bool.isRequired,
  openPanel: PropTypes.string.isRequired,
};


const DEFAULT_PANEL_WIDTH = 250;

// Variables for resizing user-list.
const USERLIST_MIN_WIDTH_PX = DEFAULT_PANEL_WIDTH;
const USERLIST_MAX_WIDTH_PX = 500;

// Variables for resizing chat.
const CHAT_MIN_WIDTH = DEFAULT_PANEL_WIDTH;
const CHAT_MAX_WIDTH = 500;

// Variables for resizing poll.
const POLL_MIN_WIDTH = DEFAULT_PANEL_WIDTH;
const POLL_MAX_WIDTH = 500;

// Variables for resizing shared notes.
const NOTE_MIN_WIDTH = DEFAULT_PANEL_WIDTH;
const NOTE_MAX_WIDTH = 500;

// Variables for resizing captions.
const CAPTIONS_MIN_WIDTH = DEFAULT_PANEL_WIDTH;
const CAPTIONS_MAX_WIDTH = 500;

// Variables for resizing waiting users.
const WAITING_MIN_WIDTH = DEFAULT_PANEL_WIDTH;
const WAITING_MAX_WIDTH = 500;

const dispatchResizeEvent = () => window.dispatchEvent(new Event('resize'));

class PanelManager extends PureComponent {
  constructor() {
    super();

    this.padKey = _.uniqueId('resize-pad-');
    this.userlistKey = _.uniqueId('userlist-');
    this.breakoutroomKey = _.uniqueId('breakoutroom-');
    this.chatKey = _.uniqueId('chat-');
    this.pollKey = _.uniqueId('poll-');
    this.noteKey = _.uniqueId('note-');
    this.captionsKey = _.uniqueId('captions-');
    this.waitingUsers = _.uniqueId('waitingUsers-');

    this.state = {
      chatWidth: DEFAULT_PANEL_WIDTH,
      pollWidth: DEFAULT_PANEL_WIDTH,
      userlistWidth: 180,
      chatHeight: 180,
      noteWidth: DEFAULT_PANEL_WIDTH,
      captionsWidth: DEFAULT_PANEL_WIDTH,
      waitingWidth: DEFAULT_PANEL_WIDTH,
    };
  }

  componentDidUpdate(prevProps) {
    const { openPanel } = this.props;
    const { openPanel: oldOpenPanel } = prevProps;

    if (openPanel !== oldOpenPanel) {
      window.dispatchEvent(new Event('resize'));
    }
  }

  renderUserList() {
    const {
      intl,
      enableResize,
      openPanel,
      shouldAriaHide,
    } = this.props;

    const ariaHidden = shouldAriaHide() && openPanel !== 'userlist';

    return (
      <div
        className={styles.userList0}
        aria-label={intl.formatMessage(intlMessages.userListLabel)}
        key={enableResize ? null : this.userlistKey}
        aria-hidden={ariaHidden}
      >
        <UserListContainer />
      </div>
    );
  }

  renderUserListResizable() {
    const { userlistWidth } = this.state;
    const { isRTL } = this.props;

    const resizableEnableOptions = {
      top: false,
      right: !isRTL,
      bottom: false,
      left: !!isRTL,
      topRight: false,
      bottomRight: false,
      bottomLeft: false,
      topLeft: false,
    };

    return (
      <Resizable
        minWidth={USERLIST_MIN_WIDTH_PX}
        maxWidth={USERLIST_MAX_WIDTH_PX}
        ref={(node) => { this.resizableUserList = node; }}
        enable={resizableEnableOptions}
        key={this.userlistKey}
        size={{ width: userlistWidth }}
        onResize={dispatchResizeEvent}
        onResizeStop={(e, direction, ref, d) => {
          this.setState({
            userlistWidth: userlistWidth + d.width,
          });
        }}
      >
        {this.renderUserList()}
      </Resizable>
    );
  }

  renderChat() {
    const { intl, enableResize, height } = this.props;

    return (
      <div
        className={styles.chat}
        aria-label={intl.formatMessage(intlMessages.chatLabel)}
        key={enableResize ? null : this.chatKey}
      >
        <ChatContainer />
      </div>
    );
  }

  renderUserListAndChatResizable() {
    const { userlistWidth, chatHeight } = this.state;
    const { isRTL } = this.props;

    const resizableEnableOptions = {
      top: false,
      right: !isRTL,
      bottom: false,
      left: !!isRTL,
      topRight: false,
      bottomRight: false,
      bottomLeft: false,
      topLeft: false,
    };

    const resizableEnableOptions2 = {
      top: false,
      right: false,
      bottom: !isRTL,
      left: false,
      topRight: false,
      bottomRight: false,
      bottomLeft: false,
      topLeft: false,
    };

    return (
      <Resizable
        minWidth={USERLIST_MIN_WIDTH_PX}
        maxWidth={USERLIST_MAX_WIDTH_PX}
        ref={(node) => { this.resizableUserList = node; }}
        enable={resizableEnableOptions}
        key={this.userlistKey}
        size={{ width: userlistWidth }}
        onResize={dispatchResizeEvent}
        onResizeStop={(e, direction, ref, d) => {
          this.setState({
            userlistWidth: userlistWidth + d.width,
          });
        }}
      >
        <Resizable
          enable={resizableEnableOptions2}
          key={this.chatKey}
          size={{ height: chatHeight }}
          onResize={dispatchResizeEvent}
          onResizeStop={(e, direction, ref, d) => {
            this.setState({
              chatHeight: chatHeight + d.height,
            });
          }}
        >
          {this.renderUserList()}
        </Resizable>
        <Resizable
          enable={resizableEnableOptions2}
          key={this.chatKey}
          size={{ height: chatHeight }}
          onResize={dispatchResizeEvent}
          onResizeStop={(e, direction, ref, d) => {
            this.setState({
              chatHeight: chatHeight + d.height,
            });
          }}
        >
          {this.renderChat()}
        </Resizable>
      </Resizable>
    );
  }

  renderUserListAndChat() {
    const { panelWidth } = this.state;
    const { isRTL } = this.props;

    const resizableEnableOptions = {
      top: false,
      right: !isRTL,
      bottom: false,
      left: !!isRTL,
      topRight: false,
      bottomRight: false,
      bottomLeft: false,
      topLeft: false,
    };


    return (
      <Resizable
        className={styles.userChatPanel}
        minWidth={USERLIST_MIN_WIDTH_PX}
        maxWidth={USERLIST_MAX_WIDTH_PX}
        ref={(node) => { this.resizablePanel = node; }}
        enable={resizableEnableOptions}
        key={this.panelKey}
        size={{ width: panelWidth, height: '100%' }}
        onResize={dispatchResizeEvent}
        onResizeStop={(e, direction, ref, d) => {
          this.setState({
            panelWidth: panelWidth + d.width,
          });
        }}
      >
        {this.renderUserList()}
        {this.renderChat()}
      </Resizable>
    );
  }


  renderChatResizable() {
    const { chatWidth } = this.state;
    const { isRTL } = this.props;

    const resizableEnableOptions = {
      top: false,
      right: !isRTL,
      bottom: false,
      left: !!isRTL,
      topRight: false,
      bottomRight: false,
      bottomLeft: false,
      topLeft: false,
    };

    return (
      <Resizable
        minWidth={CHAT_MIN_WIDTH}
        maxWidth={CHAT_MAX_WIDTH}
        ref={(node) => { this.resizableChat = node; }}
        enable={resizableEnableOptions}
        key={this.chatKey}
        size={{ width: chatWidth }}
        onResize={dispatchResizeEvent}
        onResizeStop={(e, direction, ref, d) => {
          this.setState({
            chatWidth: chatWidth + d.width,
          });
        }}
      >
        <ChatContainer />
      </Resizable>
    );
  }

  renderNote() {
    const { intl, enableResize } = this.props;

    return (
      <section
        className={styles.note}
        aria-label={intl.formatMessage(intlMessages.noteLabel)}
        key={enableResize ? null : this.noteKey}
      >
        <NoteContainer />
      </section>
    );
  }

  renderNoteResizable() {
    const { noteWidth } = this.state;
    const { isRTL } = this.props;

    const resizableEnableOptions = {
      top: false,
      right: !isRTL,
      bottom: false,
      left: !!isRTL,
      topRight: false,
      bottomRight: false,
      bottomLeft: false,
      topLeft: false,
    };

    return (
      <Resizable
        minWidth={NOTE_MIN_WIDTH}
        maxWidth={NOTE_MAX_WIDTH}
        ref={(node) => { this.resizableNote = node; }}
        enable={resizableEnableOptions}
        key={this.noteKey}
        size={{ width: noteWidth }}
        onResize={dispatchResizeEvent}
        onResizeStop={(e, direction, ref, d) => {
          this.setState({
            noteWidth: noteWidth + d.width,
          });
        }}
      >
        {this.renderNote()}
      </Resizable>
    );
  }

  renderCaptions() {
    const { intl, enableResize } = this.props;

    return (
      <section
        className={styles.captions}
        aria-label={intl.formatMessage(intlMessages.captionsLabel)}
        key={enableResize ? null : this.captionsKey}
      >
        <CaptionsContainer />
      </section>
    );
  }

  renderCaptionsResizable() {
    const { captionsWidth } = this.state;
    const { isRTL } = this.props;

    const resizableEnableOptions = {
      top: false,
      right: !isRTL,
      bottom: false,
      left: !!isRTL,
      topRight: false,
      bottomRight: false,
      bottomLeft: false,
      topLeft: false,
    };

    return (
      <Resizable
        minWidth={CAPTIONS_MIN_WIDTH}
        maxWidth={CAPTIONS_MAX_WIDTH}
        ref={(node) => { this.resizableCaptions = node; }}
        enable={resizableEnableOptions}
        key={this.captionsKey}
        size={{ width: captionsWidth }}
        onResize={dispatchResizeEvent}
        onResizeStop={(e, direction, ref, d) => {
          this.setState({
            captionsWidth: captionsWidth + d.width,
          });
        }}
      >
        {this.renderCaptions()}
      </Resizable>
    );
  }

  renderWaitingUsersPanel() {
    const { intl, enableResize } = this.props;

    return (
      <section
        className={styles.note}
        aria-label={intl.formatMessage(intlMessages.noteLabel)}
        key={enableResize ? null : this.waitingUsers}
      >
        <WaitingUsersPanel />
      </section>
    );
  }

  renderWaitingUsersPanelResizable() {
    const { waitingWidth } = this.state;
    const { isRTL } = this.props;

    const resizableEnableOptions = {
      top: false,
      right: !isRTL,
      bottom: false,
      left: !!isRTL,
      topRight: false,
      bottomRight: false,
      bottomLeft: false,
      topLeft: false,
    };

    return (
      <Resizable
        minWidth={WAITING_MIN_WIDTH}
        maxWidth={WAITING_MAX_WIDTH}
        ref={(node) => { this.resizableWaitingUsersPanel = node; }}
        enable={resizableEnableOptions}
        key={this.waitingUsers}
        size={{ width: waitingWidth }}
        onResize={dispatchResizeEvent}
        onResizeStop={(e, direction, ref, d) => {
          this.setState({
            waitingWidth: waitingWidth + d.width,
          });
        }}
      >
        {this.renderWaitingUsersPanel()}
      </Resizable>
    );
  }

  renderBreakoutRoom() {
    return (
      <div className={styles.breakoutRoom} key={this.breakoutroomKey}>
        <BreakoutRoomContainer />
      </div>
    );
  }

  renderPoll() {
    return (
      <div className={styles.poll} key={this.pollKey}>
        <PollContainer />
      </div>
    );
  }

  renderPollResizable() {
    const { pollWidth } = this.state;
    const { isRTL } = this.props;

    const resizableEnableOptions = {
      top: false,
      right: !isRTL,
      bottom: false,
      left: !!isRTL,
      topRight: false,
      bottomRight: false,
      bottomLeft: false,
      topLeft: false,
    };

    return (
      <Resizable
        minWidth={POLL_MIN_WIDTH}
        maxWidth={POLL_MAX_WIDTH}
        ref={(node) => { this.resizablePoll = node; }}
        enable={resizableEnableOptions}
        key={this.pollKey}
        size={{ width: pollWidth }}
        onResizeStop={(e, direction, ref, d) => {
          window.dispatchEvent(new Event('resize'));
          this.setState({
            pollWidth: pollWidth + d.width,
          });
        }}
      >
        {this.renderPoll()}
      </Resizable>
    );
  }

  render() {
    const { enableResize, openPanel } = this.props;
    if (openPanel === '') return null;
    const panels = [];
    if (enableResize) {
      panels.push(
        this.renderUserListAndChat(),
        <div className={styles.userlistPad} key={this.padKey} />,
      );
    } else {
      panels.push(this.renderUserList());
	  if (openPanel === 'chat') {
        panels.push(this.renderChat());
	  }
    }

    /*
    if (openPanel === 'note') {
      if (enableResize) {
        panels.push(this.renderNoteResizable());
      } else {
        panels.push(this.renderNote());
      }
    }

    if (openPanel === 'captions') {
      if (enableResize) {
        panels.push(this.renderCaptionsResizable());
      } else {
        panels.push(this.renderCaptions());
      }
    }

    if (openPanel === 'poll') {
      if (enableResize) {
        panels.push(this.renderPollResizable());
      } else {
        panels.push(this.renderPoll());
      }
    }

    if (openPanel === 'breakoutroom') {
      if (enableResize) {
        panels.push(this.renderBreakoutRoom());
      } else {
        panels.push(this.renderBreakoutRoom());
      }
    }

    if (openPanel === 'waitingUsersPanel') {
      if (enableResize) {
        panels.push(this.renderWaitingUsersPanelResizable());
      } else {
        panels.push(this.renderWaitingUsersPanel());
      }
    }
*/
    return panels;
  }
}

export default injectIntl(PanelManager);

PanelManager.propTypes = propTypes;
