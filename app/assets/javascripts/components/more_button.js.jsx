var MoreButton = React.createClass({
  handleClick: function(e) {
    e.preventDefault();
    this.props.showTender(this.props.refNo);
  },
  render: function() {
    return (
      <a className='button more-button ga-tenders' data-gtm-category='' data-gtm-action='more' data-gtm-label={this.props.refNo.replace('/','\\\/')} onClick={this.handleClick}>More</a>
    );
  }
});