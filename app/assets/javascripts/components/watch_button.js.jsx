var WatchButton = React.createClass({
  render: function() {
    var id = "watch-tender-" + this.props.refNo;
    return (
      <div id={id}>
        <a href={this.props.watchPath} data-remote='true' data-method='post' className='button watch-button ga-tenders' data-gtm-category='' data-gtm-action='watch' data-gtm-label={this.props.refNo}>Watch</a>
      </div>
    );
  }
});