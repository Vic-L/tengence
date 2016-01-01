var WatchButton = React.createClass({
  handleClick: function(e) {
    e.preventDefault();
    this.props.watchTender(this.props.refNo);
  },
  render: function() {
    var id = "watch-tender-" + this.props.refNo;
    return (
      <div id={id}>
        <a className='button watch-button ga-tenders' data-gtm-category='' data-gtm-action='watch' data-gtm-label={this.props.refNo} onClick={this.handleClick}>Watch</a>
      </div>
    );
  }
});