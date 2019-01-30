# ExpenseManager

Expense Manager is an app that gives you insights about how you're spending your money.

I have used PieChart library (https://github.com/i-schuetz/PieCharts) to visualize expenses (and incomes) in this project.
Also there's a persistence mechanism which is mainly copied from (https://gist.github.com/saoudrizwan/b7ab1febde724c6f30d8a555ea779140) and is used to simply save and load transaction data when app is closed and reopened. Data is actually stored using a singleton (DataProvider.shared).
