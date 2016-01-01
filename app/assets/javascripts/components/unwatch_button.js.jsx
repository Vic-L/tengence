var UnwatchButton = React.createClass({
  handleClick: function(e) {
    e.preventDefault();
    this.props.unwatchTender(this.props.refNo);
  },
  render: function() {
    $("a.watch-button[data-gtm-label=" + this.props.refNo + "]").siblings('.notifyjs-wrapper').remove();
    return (
      <a className='button unwatch-button ga-tenders' data-gtm-category='' data-gtm-action='unwatch' data-gtm-label={this.props.refNo} onClick={this.handleClick}>Unwatch</a>
    );
  }
});