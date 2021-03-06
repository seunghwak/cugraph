from libcpp cimport bool

cdef extern from "cudf.h":

    ctypedef size_t gdf_size_type

    #cpdef get_column_data_ptr(obj)

    ctypedef enum gdf_time_unit:
        TIME_UNIT_NONE=0
        TIME_UNIT_s,
        TIME_UNIT_ms,
        TIME_UNIT_us,
        TIME_UNIT_ns

    ctypedef struct gdf_dtype_extra_info:
        gdf_time_unit time_unit

    ctypedef enum gdf_error: 

        pass

    ctypedef enum gdf_dtype:
        GDF_invalid=0,
        GDF_INT8,
        GDF_INT16,
        GDF_INT32,
        GDF_INT64,
        GDF_FLOAT32,
        GDF_FLOAT64,
        GDF_DATE32,
        GDF_DATE64,
        GDF_TIMESTAMP,
        GDF_CATEGORY,
        GDF_STRING,
        N_GDF_TYPES

    ctypedef unsigned char gdf_valid_type

    ctypedef struct gdf_column:
        void *data
        gdf_valid_type *valid
        gdf_size_type size
        gdf_dtype dtype
        gdf_size_type null_count
        gdf_dtype_extra_info dtype_info
        char *col_name

    cdef gdf_error gdf_column_view_augmented(gdf_column *column,
                                             void *data,
                                             gdf_valid_type *valid,
                                             gdf_size_type size,
                                             gdf_dtype dtype,
                                             gdf_size_type null_count,
                                             gdf_dtype_extra_info extra_info)




cdef extern from "cugraph.h":

    struct gdf_edge_list:
        gdf_column *src_indices
        gdf_column *dest_indices
        gdf_column *edge_data

    struct gdf_adj_list:
        gdf_column *offsets
        gdf_column *indices
        gdf_column *edge_data
        gdf_error get_vertex_identifiers(gdf_column *identifiers)
        gdf_error get_source_indices(gdf_column *indices)

    struct gdf_graph:
        gdf_edge_list *edgeList
        gdf_adj_list *adjList
        gdf_adj_list *transposedAdjList


    cdef gdf_error gdf_renumber_vertices(const gdf_column *src,
    	 	   			 const gdf_column *dst,
				         gdf_column *src_renumbered,
					 gdf_column *dst_renumbered,
				         gdf_column *numbering_map)

    cdef gdf_error gdf_edge_list_view(gdf_graph *graph,
                             const gdf_column *source_indices,
                             const gdf_column *destination_indices,
                             const gdf_column *edge_data)
    cdef gdf_error gdf_add_edge_list(gdf_graph *graph)
    cdef gdf_error gdf_delete_edge_list(gdf_graph *graph)
    cdef gdf_error gdf_adj_list_view (gdf_graph *graph,
                             const gdf_column *offsets,
                             const gdf_column *indices,
                             const gdf_column *edge_data)
    cdef gdf_error gdf_add_adj_list(gdf_graph *graph)
    cdef gdf_error gdf_delete_adj_list(gdf_graph *graph)
    cdef gdf_error gdf_get_two_hop_neighbors(gdf_graph* graph, gdf_column* first, gdf_column* second)
    cdef gdf_error gdf_add_transposed_adj_list(gdf_graph *graph)
    cdef gdf_error gdf_delete_transposed_adj_list(gdf_graph *graph)

    cdef gdf_error gdf_degree(gdf_graph *graph, gdf_column *degree, int x)    
