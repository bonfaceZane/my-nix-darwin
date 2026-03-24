---
name: tanstack-query
description: TanStack Query v5 patterns for data fetching in the amv-apps monorepo. Use for queries, mutations, caching, and optimistic updates.
version: 1.0.0
---

# TanStack Query v5

## Version
`@tanstack/react-query` v5.64.2 with `@tanstack/react-query-persist-client` + AsyncStorage persister.

## Key v5 Changes (from v4)
- `useQuery` no longer has `onSuccess`/`onError`/`onSettled` callbacks — use `useEffect` or mutation callbacks
- `cacheTime` renamed to `gcTime`
- `status: 'loading'` renamed to `status: 'pending'`
- `isLoading` is now `isPending`
- Object form only for query options: `useQuery({ queryKey, queryFn })`

## Patterns

### Query keys — always typed arrays
```ts
const keys = {
  listings: (filters: Filters) => ['listings', filters] as const,
  listing: (id: string) => ['listing', id] as const,
}
```

### Queries
```ts
const { data, isPending, isError } = useQuery({
  queryKey: keys.listing(id),
  queryFn: () => api.getListing(id),
  staleTime: 1000 * 60 * 5, // 5 min
})
```

### Mutations with optimistic updates
```ts
const mutation = useMutation({
  mutationFn: api.updateListing,
  onMutate: async (newData) => {
    await queryClient.cancelQueries({ queryKey: keys.listing(id) })
    const previous = queryClient.getQueryData(keys.listing(id))
    queryClient.setQueryData(keys.listing(id), newData)
    return { previous }
  },
  onError: (_, __, context) => {
    queryClient.setQueryData(keys.listing(id), context?.previous)
  },
  onSettled: () => queryClient.invalidateQueries({ queryKey: keys.listing(id) }),
})
```

### Persistence (AsyncStorage)
Configured with `@tanstack/react-query-persist-client`. Long-lived cache survives app restarts. Set `gcTime` > persister `maxAge` to keep data alive.

### Prefetching
```ts
await queryClient.prefetchQuery({ queryKey: keys.listings(filters), queryFn: ... })
```

## ESLint
`@tanstack/eslint-plugin-query` is enabled — follow its rules, especially exhaustive deps on query keys.
