var DemoTendersPagination = React.createClass({
  setPagesRange: function(current_page, total_pages) {
    var range = [], startPage, endPage;
    if ((current_page - 4) <= 0) {
      startPage = 1;
    } else {
      startPage = current_page - 4;
    }
    if ((current_page + 4) > total_pages) {
      endPage = total_pages;
    } else {
      endPage = current_page + 4;
    }
    for (var i = startPage; i <= endPage; i++) {
      range.push(i);
    }
    return range;
  },
  handleChange: function(e){
    Tengence.ReactFunctions.trackSort(e.target.value);
    e.preventDefault();
    Tengence.HomePage.promptRegistration();
  },
  handleClick: function(e){
    e.preventDefault();
    Tengence.HomePage.promptRegistration();
  },
  render: function() {
    var {pagination, ...others} = this.props; 
    if (Object.keys(pagination).length === 0) return (<div></div>);
    var range = this.setPagesRange(pagination.current_page, pagination.total_pages);
    var links = [];
    if (pagination.current_page !== 1) {
      links.push(<a href='' className='ga-static-pages' data-gtm-category='' data-gtm-action='pagination first' data-gtm-label='demo' onClick={this.handleClick}>« First</a>);
      links.push(<a href='' className='ga-static-pages' data-gtm-category='' data-gtm-action='pagination prev' data-gtm-label='demo' onClick={this.handleClick}>‹ Prev</a>);
    }
    if (range.length != 0 && range[0] !== 1) {
      links.push(<span>…</span>); 
    }
    for (var i=0;i<range.length;i++) {
      var current = null;
      if (i === 0) {
        links.push(<span>{range[i]}</span>);
      } else {
        links.push(<a href='' data-gtm-category='' data-gtm-action={'pagination ' + range[i]} data-gtm-label='demo' className={current ? 'current_page_' + range[i] : 'page_' + range[i] + ' ga-static-pages'} onClick={this.handleClick}>{range[i]}</a>);
      }
    }
    if (range.length != 0 && range[range.length - 1] !== pagination.total_pages) {
      links.push(<span>…</span>);
    }
    if (!pagination.last_page) {
      links.push(<a href='' className='ga-static-pages' data-gtm-category='' data-gtm-action='pagination next' data-gtm-label='demo' onClick={this.handleClick}>Next ›</a>);
      links.push(<a href='' className='ga-static-pages' data-gtm-category='' data-gtm-action='pagination last' data-gtm-label='demo' onClick={this.handleClick}>Last »</a>);
    }
    return (
      <div className='row pagination-row'>
        <div className='small-6 medium-3 column'>
          Sort By:<select className='sort' onChange={this.handleChange} value='newest'><option value="newest">Newest</option><option value="expiring">Expiring</option></select>
        </div>
        <div className='small-6 medium-9 column text-right tender-pagination'>
          <nav className="pagination">
            {links}
          </nav>| Total Tenders:
          <span className="total-count">{this.props.results_count}</span>
        </div>
      </div>
    );
  }
});