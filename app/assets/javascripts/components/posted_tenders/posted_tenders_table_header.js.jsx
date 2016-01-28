var PostedTendersTableHeader = React.createClass({
  render: function() {
    return (
      <thead>
        <tr>
          <th className='medium-6'>Description</th>
          <th className='medium-1 hide-for-small'>Published Date</th>
          <th className='medium-2'>Closing Date</th>
          <th className='medium-1 hide-for-small'>Closing Time</th>
          <th className='medium-1 hide-for-small'>Watchlist</th>
          <th className='medium-1'>Details</th>
        </tr>
      </thead>
    );
  }
});