var UnwatchButton = React.createClass({
  handleClick: function(e) {
    e.preventDefault();
    this.props.unwatchTender(this.props.refNo);
  },
  render: function() {
    return (
      <a className='button unwatch-button ga-tenders' data-gtm-category='' data-gtm-action='unwatch' data-gtm-label={this.props.refNo} onClick={this.handleClick}>Unwatch</a>
    );
  }
});