var DemoTenderRow = React.createClass({
  handleClick: function(){
    Tengence.HomePage.promptRegistration();
  },
  render: function() {
    var moreButton;
    if (this.props.index === 0) {
      moreButton = <MoreButton refNo={this.props.refNo}/>
    } else {
      moreButton = <a className='button more-button disabled round' onClick={this.handleClick} disabled>More</a>;
    };
    return (
      <tr>
        <td>{this.props.description}</td>
        <td className='hide-for-small'>{this.props.publishedDate}</td>
        <td>{this.props.closingDate}</td>
        <td className='hide-for-small'>{this.props.closingTime}</td>
        <td>{this.props.buyerCompanyName}</td>
        <td className='hide-for-small'><a className='button watch-button round' onClick={this.handleClick}>Watch</a></td>
        <td>{moreButton}</td>
      </tr>
    );
  }
});
