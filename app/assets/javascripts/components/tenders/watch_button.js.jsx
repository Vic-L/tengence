var WatchButton = React.createClass({
  handleClick: function(e) {
    e.preventDefault();
    Tengence.ReactFunctions.watchTender(this.props.parentComponent,this.props.refNo);
  },
  render: function() {
    $("a.unwatch-button[data-gtm-label='" + this.props.refNo + "']").siblings('.notifyjs-wrapper').remove();
    return (
      <a className='button watch-button round ga-tenders' data-gtm-category='' data-gtm-action='watch' data-gtm-label={this.props.refNo} onClick={this.handleClick}>Watch</a>
    );
  }
});