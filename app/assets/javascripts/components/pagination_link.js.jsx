var PaginationLink = React.createClass({
  render: function(){
    if (this.props.path != null){
      return <a href={this.props.path + '?page=' + this.props.page}> {this.props.children} </a>
    } else {
      return <span> {this.props.children} </span>
    }
  }
})