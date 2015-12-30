var WatchButton = React.createClass({
  render: function() {
    return (
      <a href={this.props.watchPath} data-remote='true' data-method='post' className='button watch-button ga-tenders' data-gtm-category='' data-gtm-action='watch' data-gtm-label={this.props.refNo}>Watch</a>
    );
  }
});