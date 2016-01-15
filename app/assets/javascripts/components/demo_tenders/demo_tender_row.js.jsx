var DemoTenderRow = React.createClass({
  handleClick: function(){
    Tengence.HomePage.promptRegistration();
  },
  render: function() {
    var moreButton;
    if (this.props.index === 0 || this.props.index%12 === 0) {
      moreButton = <MoreButton refNo={this.props.refNo}/>
    } else {
      moreButton = <a className='button more-button' onClick={this.handleClick} disabled>More</a>;
    };
    return (
      <tr>
        <td>{this.props.description}</td>
        <td>{this.props.publishedDate}</td>
        <td>{this.props.closingDate}</td>
        <td>{this.props.closingTime}</td>
        <td>{this.props.buyerCompanyName}</td>
        <td><a className='button watch-button' onClick={this.handleClick}>Watch</a></td>
        <td>{moreButton}</td>
      </tr>
    );
  }
});
