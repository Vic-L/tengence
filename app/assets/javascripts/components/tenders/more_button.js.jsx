var MoreButton = React.createClass({
  handleClick: function(e) {
    e.preventDefault();
    // console.log(this.props.parentComponent);
    Tengence.ReactFunctions.showTender(this.props.refNo, this.props.trial_tender_ids, this.props.parentComponent);
  },
  render: function() {
    return (
      <a className='button more-button ga-tenders' data-gtm-category='' data-gtm-action='more' data-gtm-label={this.props.refNo.replace('/','\\\/')} onClick={this.handleClick}>More</a>
    );
  }
});