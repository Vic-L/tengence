var UnwatchButton = React.createClass({
  handleClick: function(e) {
    e.preventDefault();
    this.props.unwatchTender(this.props.refNo);
  },
  render: function() {
    var id = "watch-tender-" + this.props.refNo;
    return (
      <div id={id}>
        <a className='button unwatch-button ga-tenders' data-gtm-category='' data-gtm-action='unwatch' data-gtm-label={this.props.refNo} onClick={this.handleClick}>Unwatch</a>
      </div>
    );
  }
});